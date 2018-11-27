/*
 * Hunt - Hunt is a high-level D Programming Language Web framework that encourages rapid development and clean, pragmatic design. It lets you build high-performance Web applications quickly and easily.
 *
 * Copyright (C) 2015-2018  Shanghai Putao Technology Co., Ltd
 *
 * Website: www.huntframework.com
 *
 * Licensed under the Apache-2.0 License.
 *
 */

module hunt.framework;

public import hunt.framework.versions;
public import hunt.framework.init;
public import hunt.framework.application;
public import hunt.framework.routing;
public import hunt.cache;
public import hunt.framework.http;
public import hunt.framework.view;
public import hunt.validation;

debug {}
else {
    import hunt.lang.common;
    static assert(CompilerHelper.isGreater(2082), 
        "The version of D compiler must be greater than 2.083 in release model.");
}