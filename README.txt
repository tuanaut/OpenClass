#######################################################################

			      EBM (C) 2017
		Anthony Handzel, Jacob Mann, Jerry Chiu,
		   Oscar Santiago-Sanchez, Tuan Chau


#######################################################################

				README.txt

CONTENTS:
	1. Release Cycle
	2. Important Links

-----------------------------------------------------------------------
			    1. Release Cycle
-----------------------------------------------------------------------

The Release Cycle for EBM follows the following pattern,
according to the release dates (due dates) determined by the CS 472
class schedule:
	1. Either Clone the repository or pull changes since your
	last edit.

	2. Branch from Develop, naming your branch in a way relevant
	to the bug or feature you're working on. For example:

	feature/implement_sql_scripts

	-or-

	patch/fix_buffer_ovrflw_vuln

	3. After completing your work on your branch, push the branch
	to BitBucket and create a pull request to merge into develop.
	Only merge your changes after the code has at least one
	approval. The reviewer should attempt to build and (if
	applicable) test the changes made to the code before approving
	the changes.

	4. Merge the changes into develop. A test build will later be
	run to ensure that the day's changes all work.

When preparing for a release (due date), a new branch will be made
off of develop, indicating the release date (e.g. release/9.30.17),
one week before the date of release. This will allow us time to
work out any last-minute bugs from the release candidate. During
this time, any changes made to the RC must also be applied to the
develop branch by following the above steps so that develop remains
in sync with the RC. Once the release date is passed, work will
continue only on develop.

-----------------------------------------------------------------------
			    2. Important Links
-----------------------------------------------------------------------
Repository Overview:
	https://bitbucket.org/stefika/fall2017-resaleapp/overview

Database Design:
	https://docs.google.com/a/unlv.nevada.edu/drawings/d/1YRb5SXHjFHWUKafRSShl8EgdOyPeI-LxfpcOnbwEfQo/edit?usp=sharing
