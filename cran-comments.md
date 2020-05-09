## Test environments
* Ubuntu 18.04, R 3.4.4
* Ubuntu 16.04 on Travis-CI

## R CMD check results

This is a first submission.

There were no ERRORs, WARNINGs and one NOTE
indicating this is a first submission.

## Comments

This is a resubmission of the initial CRAN submission following
the feedback.

What has changed:

Previous submission had the following missing Rd-tags:

- getInputId.Rd: \value -- FIXED
- ShinyForm.Rd: \arguments,  \value -- NOT FIXED (R6Class, these tags should not be required?)
- shinyReformsDependency.Rd: \arguments,  \value -- FIXED (\value now present, but this
	function takes no arguments)
- shinyReformsPage.Rd: \value -- FIXED
- Validator.Rd: \arguments,  \value -- NOT FIXED (R6Class, these tags should not be required?)
- ValidatorMaxLength.Rd: \value -- FIXED
- ValidatorMinLength.Rd: \value -- FIXED
- ValidatorNonEmpty.Rd: \arguments,  \value -- FIXED (\value now present, but this
	function takes no arguments)
- ValidatorRequired.Rd: \arguments,  \value -- FIXED (\value now present, but this
	function takes no arguments)

On \value and \arguments for R6Class: the \arguments for the
constructor are part of the `new` method documentation and I can't really see
a place for \value tag there.

Also, is \arguments section in functions which take no arguments really needed?
