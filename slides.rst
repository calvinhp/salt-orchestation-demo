.. -*- coding: utf-8 -*-

...  Copyright 2019 Six Feet Up, Inc.

     Licensed under the Apache License, Version 2.0 (the "License");
     you may not use this file except in compliance with the License.
     You may obtain a copy of the License at

         http://www.apache.org/licenses/LICENSE-2.0

     Unless required by applicable law or agreed to in writing, software
     distributed under the License is distributed on an "AS IS" BASIS,
     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
     See the License for the specific language governing permissions and
     limitations under the License.

:title: Deployment Automation and Orchestration with SaltStack
:event: IndyPy Python Web Conf 2019
:author: Calvin Hendryx-Parker
:pygments: tango
:css: custom.css

.. |space| unicode:: 0xA0 .. non-breaking space
.. |br| raw:: html

    <br />

----

Deployment Automation and Orchestration with SaltStack
======================================================

Calvin Hendryx-Parker, CTO
++++++++++++++++++++++++++

Six Feet Up, Inc.
-----------------

`@calvinhp <http://twitter.com/calvinhp>`__

.. note::

    What types of sites will we be deploying?

----

What is the end goal?
=====================

* Reliable
* Consistent
* Repeatable
* Scalable
* (and preferably as automated as possible)

----

What is Salt?
=============

Event Driven Datacenter Orchestration
+++++++++++++++++++++++++++++++++++++

----

What sets Salt apart from other configuration management tools?
===============================================================

* Remote Execution
* Event-Driven Orchestration
* Agent or Agent-less Operation
* Cloud Provisioning
* Speed and Scalability

.. note::
    Combines many tools such as:

    * chef/puppet

    * fabric for orchestration

    * terraform for cloud provisioning

----

Salt Architecture
=================

* Masters
* Minions

Follow along with this presentation:
++++++++++++++++++++++++++++++++++++

http://github.com/calvinhp/salt-orchestation-demo
-------------------------------------------------

.. note::
    Show the running cluster

    * Demo remote execution

    * salt proxy haproxy.show_backends

    * salt proxy haproxy.list_servers django

    * Do it across multiple servers

    * salt '*' user.info dev1

----

Salt Terminology
================

* States
* Pillars
* Reactors
* Mines
* Events
* Beacons

.. note::

    dive deeper into the structure of the state files

    Show the event steam in the terminal, run a state.

    Show the difference between a normal state and one that has been turned into a "Formula"

    Make sure to setup check so that certain states such as `file.touch` don't run every time, but only if a file is missing.


----

Dependency Management in Salt
=============================

* Requisite System
* Great for Configuration Management

.. note::
    Show the django.sls state to show how it has dependancies

    + Use `require` to set the order of operation

    + Trickiest bit is the ordering of the operations

    * learn the Requisite system of Salt well and it will pay back in dividends

    * Use `watch` with services to restart them if the configuration file changes

    * Use `listen` vs `watch` if you might have multiple states that would want to restart the service


----

Using Dependencies with Orchestration
=====================================

* True `master` control
* Orchestrate from above
* Cross minion dependencies

.. note::

    demo the code release orchestration state

----

Adding a REST API to salt
=========================

* Multiple Authentication Back-ends
* Supports ACLs
* Full async websockets for event notifications

.. note::
    External Auth supports many different backends

    Show master config, you can control who can do what.

    Show that this is setup via salt itself

    How do we replace fabric?

    Use salt-pepper to control the master with external auth

----

Use Reactors to Orchestrate
===========================

* Salt new `minions` as they are created
* Heal broken services by attempting common fixes

.. note::
    vagrant up the app3 server

    show haproxy status

    remove the key for app2

    show, and then add back

----

Questions?
==========

Thanks!
+++++++

Get this project:

http://github.com/calvinhp/salt-orchestation-demo

`@calvinhp <http://twitter.com/calvinhp>`__
