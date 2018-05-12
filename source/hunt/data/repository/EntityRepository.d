/*
 * Entity - Entity is an object-relational mapping tool for the D programming language. Referring to the design idea of JPA.
 *
 * Copyright (C) 2015-2018  Shanghai Putao Technology Co., Ltd
 *
 * Developer: HuntLabs.cn
 *
 * Licensed under the Apache-2.0 License.
 *
 */
 
module hunt.data.repository.EntityRepository;

import hunt.data.repository.CrudRepository;
public import hunt.data.domain;
import entity;


class EntityRepository (T, ID) : CrudRepository!(T, ID)
{

	static string tableName()
	{
		return getUDAs!(getSymbolsByUDA!(T, Table)[0], Table)[0].name;
	}


	static string init_code()
	{
		return `		auto em = this.createEntityManager();
		CriteriaBuilder builder = em.getCriteriaBuilder();	
		auto criteriaQuery = builder.createQuery!T;
		Root!T root = criteriaQuery.from();`;
	}


	long count(Specification!T specification)
	{
		mixin(init_code);

		criteriaQuery.select(builder.count(root)).where(specification.toPredicate(
				root , criteriaQuery , builder));
		
		Long result = cast(Long)(em.createQuery(criteriaQuery).getSingleResult());
		em.close();
		return result.longValue();
	}

	T[] findAll(Sort sort)
	{
		mixin(init_code);

		//sort
		foreach(o ; sort.list)
			criteriaQuery.getSqlBuilder().orderBy(tableName ~ "." ~ o.getColumn() , o.getOrderType());

		//all
		criteriaQuery.select(root);

		TypedQuery!T typedQuery = em.createQuery(criteriaQuery);
		auto res = typedQuery.getResultList();
		em.close();
		return res;
	}


	T[] findAll(Specification!T specification)
	{
		mixin(init_code);

		//specification
		criteriaQuery.select(root).where(specification.toPredicate(
				root , criteriaQuery , builder));

		TypedQuery!T typedQuery = em.createQuery(criteriaQuery);
		auto res = typedQuery.getResultList();
		em.close();
		return res;
	}

	T[] findAll(Specification!T specification , Sort sort)
	{
		mixin(init_code);

		//sort
		foreach(o ; sort.list)
			criteriaQuery.getSqlBuilder().orderBy(tableName ~ "." ~ o.getColumn() , o.getOrderType());

		//specification
		criteriaQuery.select(root).where(specification.toPredicate(
				root , criteriaQuery , builder));

		TypedQuery!T typedQuery = em.createQuery(criteriaQuery);
		auto res = typedQuery.getResultList();
		em.close();
		return res;
	}


	Page!T findAll(Pageable pageable)
	{
		mixin(init_code);

		//sort
		foreach(o ; pageable.getSort.list)
			criteriaQuery.getSqlBuilder().orderBy(tableName ~ "." ~ o.getColumn() , o.getOrderType());

		//all
		criteriaQuery.select(root);

		//page
		TypedQuery!T typedQuery = em.createQuery(criteriaQuery).setFirstResult(pageable.getOffset())
				.setMaxResults(pageable.getPageSize());
		auto res = typedQuery.getResultList();
		auto page = new Page!T(res , pageable , super.count());
		em.close();
		return page;
	}

	Page!T findAll(Specification!T specification, Pageable pageable)
	{
		mixin(init_code);

		//sort
		foreach(o ; pageable.getSort.list)
			criteriaQuery.getSqlBuilder().orderBy(tableName ~"." ~ o.getColumn() , o.getOrderType());

		//specification
		criteriaQuery.select(root).where(specification.toPredicate(
				root , criteriaQuery , builder));
				
		//page
		TypedQuery!T typedQuery = em.createQuery(criteriaQuery).setFirstResult(pageable.getOffset())
			.setMaxResults(pageable.getPageSize());
		auto res = typedQuery.getResultList();
		auto page = new Page!T(res , pageable , super.count());
		em.close();
		return page;
	}

}

/*
string orderByIDDesc(T)()
{
	string code = "criteriaQuery.orderBy(builder.desc(root."~ T.stringof ~"."~ getSymbolsByUDA!(T, PrimaryKey)[0].stringof ~"));";
	return code;
}*/

unittest{
	//todo next add config mysql & test.
	version(NEXT)
	{
		import hunt.data.repository;
		import hunt.data.domain;
		import entity;
		import kiss.logger;
		
		@Table("p_menu")
		class Menu : Entity
		{
			@PrimaryKey
			@AutoIncrement
			int 		ID;
			
			string 		name;
			int 		up_menu_id;
			string 		perident;
			int			index;
			string		icon;
			bool		status;
		}
		
		
		void test()
		{
			auto rep = new EntityRepository!(Menu , int)();
			
			//sort
			auto menus1 = rep.findAll(new Sort("ID" , OrderBy.DESC));
			foreach(m ; menus1)
			{
				logInfo(m.ID , " " , m.name);
			}
			
			//specification
			class MySpecification: Specification!Menu
			{
				Predicate toPredicate(Root!Menu root, CriteriaQuery!Menu criteriaQuery ,
					CriteriaBuilder criteriaBuilder)
				{
					Predicate _name = criteriaBuilder.gt(root.Menu.ID, 5);
					return criteriaBuilder.and(_name);
				}
			}
			
			auto menus2 = rep.findAll(new MySpecification());
			foreach(m ; menus2)
			{
				logInfo(m.ID , " " , m.name);
			}
			
			//sort specification
			auto menus3 = rep.findAll(new MySpecification , new Sort("name" ,OrderBy.DESC));
			foreach(m ; menus3)
			{
				logInfo(m.ID , " " , m.name);
			}
			
			
			
			//page
			auto pages1 = rep.findAll(new Pageable(0 , 10 , "ID" , OrderBy.DESC));
			foreach(m ; pages1.getContent)
			{
				logInfo(m.ID , " " , m.name);
			}
			
			//page specification
			auto pages2 = rep.findAll(new MySpecification , new Pageable(0 , 10 , "ID" , OrderBy.DESC));
			foreach(m ; pages2.getContent)
			{
				logInfo(m.ID , " " , m.name);
			}
			
			
			
			
		}

	}

}



