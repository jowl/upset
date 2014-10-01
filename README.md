# Veritas

Veritas, meaning truth, is a configuration management library that
provides functionality for defining, providing, and inspecting
application configuration.

## Definition

It should be clear which configuration properties can or must be set
and if there are any default values. Moreover, it should be clear what
kind of values are allowed for a particular configuration
property. The provided configuration should be validated as soon as
possible to minimize the effects of mis-configuration. (Built-in
support for basic types, files, hosts, ...?)

## Provision

A configuration provider decouples the format of the stored
configuration from the usage of that configuration. By injecting a
configuration provider, the underlying configuration's format can be
changed without having to touch the code using the configured
values. (Built-in support for hard-coded strings, YAML,
key-value-files, ...?)

## Inspection

It is not possible to determine which configuration is being used in
an application by looking at the configuration source, since it might
have been changed since it was loaded into the application. It should
therefore be possible to inspect the used configuration in some
way. When there are multiple sources of configuration (e.g. CLI
options, configuration file, hard-coded defaults, etc.), it should
also be possible to determine from which source the current value
originates. (Built-in support for programmatical inspection, ...?)
