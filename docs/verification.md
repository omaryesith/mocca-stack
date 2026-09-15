# Verification contract

Run `./scripts/verify` before declaring Mocca work complete.

It runs the repository's shell checks, bootstrap contract test, and committed
credential scan. CI invokes the same command. The generated-workspace
verification contract is separately defined by `templates/core/scripts/verify`.

If a required check cannot run because of the environment, report the specific
limitation rather than claiming verification passed.
