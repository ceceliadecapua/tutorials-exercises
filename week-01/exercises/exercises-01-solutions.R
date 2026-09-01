# exercise-01 solutions

# Week 1 Independent Exercises: GitHub Workflow ---------------------------
#
# ANSWER KEY
#
# Estimated time: 25–30 minutes
#
# Work independently. Use the Week 1 tutorial as a reference when needed.
#
# The goal is to practice the GitHub workflow without following along with
# the instructor.
#
# Complete this file inside:
#
# tutorials-exercises/week-01/exercises/
#
# When finished, you will:
#
# 1. save your work;
# 2. review your changes using Diff;
# 3. stage the file;
# 4. commit your changes;
# 5. push the commit to GitHub; and
# 6. verify that the file appears in the remote GitHub repository.


# Part 1. GitHub terminology ----------------------------------------------

# 1. What is the difference between clone and pull?
#
# Answer:
# Clone downloads a repository from GitHub to your computer (local) for the first
# time. Pull downloads new changes from GitHub into a repository that you
# have already cloned.


# 2. What is the difference between commit and push?
#
# Answer:
# Commit saves a checkpoint of your changes in the Git history on your
# computer. Push uploads your local commits to the remote repository
# on GitHub.


# 3. Which repository contains the instructor's original course materials?
#
# Answer:
# course-hub


# 4. Which repository should contain your completed tutorials and exercises?
#
# Answer:
# tutorials-exercises


# 5. What should you do before beginning work in a repository that you have
#    already cloned to your computer?
#
# Answer:
# Open the existing RStudio Project rather than cloning the repository again.
# If the remote repository may have been updated, pull the latest changes
# before beginning your work.


# Part 2. Review your changes ---------------------------------------------

# Save this file, then open the Git pane in RStudio.
#
# You should see this file listed with a status symbol.
#
# Common symbols:
#
# ? = new, untracked file
# M = modified file
# D = deleted file
#
# Before committing:
#
# 1. Select exercises-01-github.R in the Git pane.
# 2. Click Diff.
# 3. Review the lines you added.
# 4. Confirm that you changed only the intended file.
# 5. Check the box next to exercises-01-github.R to stage the file.
#
# Answer/check:
# The Diff should show the answers that you added to this file. Make sure
# there are no unexpected changes to other files.


# Part 3. Commit and push -------------------------------------------------

# Create a commit using the following message:
#
# 'add GitHub terminology practice'
#
# Then push the commit to the remote GitHub repository.
#
# Answer/check:
# After committing, the changes have been recorded in the Git history on
# your computer.
#
# After pushing, that commit should also appear in the remote repository
# on GitHub.


# Part 4. Verify your work ------------------------------------------------

# Open your tutorials-exercises repository on GitHub (the remote).
#
# Confirm that:
#
# 1. exercises-01-github.R appears in week-01/exercises/;
# 2. your answers are visible; and
# 3. your most recent commit appears in the repository history.
#
# Answer/check:
# You should be able to open exercises-01-github.R on GitHub and see the
# answers you wrote above.
#
# The most recent commit should have the message:
#
# 'add GitHub terminology practice'


# Part 5. Practice the workflow again ------------------------------------

# Answer the following question:
#
# One Git concept I understand better now is:
#
# Example answer:
# I understand that a commit saves a checkpoint locally, while a push sends
# that commit to the remote repository on GitHub.
#
# Other reasonable answers are possible.


# Save the file again, then repeat: 
#
# Review -> Stage -> Commit -> Push -> Verify remote
#
# Add a reflection about today and use this commit message:
#
# 'add reflection'
#
# Answer/check:
# After pushing, GitHub should show two commits:
#
# 1. add GitHub terminology practice
# 2. add reflection
#
# The second commit should contain the reflection you added above.


# Part 6. Reopen the existing project ------------------------------------

# Close the RStudio Project.
#
# Reopen tutorials-exercises using the tutorials-exercises.Rproj file.
#
# Do not clone the repository again.
#
# Confirm that:
#
# - tutorials-exercises is the active project; and
# - this exercise file is still present.
#
# Answer/check:
# The tutorials-exercises repository already exists on your computer, so
# you should reopen the existing .Rproj file rather than cloning the
# repository again.


# Completion checklist ----------------------------------------------------

# [ ] I completed all questions.
# [ ] I reviewed my changes using Diff.
# [ ] I staged the file after reviewing my changes.
# [ ] I created the first commit.
# [ ] I pushed the first commit.
# [ ] I verified the file on GitHub.
# [ ] I made a second change.
# [ ] I created and pushed a second commit.
# [ ] I reopened the existing RStudio Project without cloning it again.