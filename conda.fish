function fish_prompt -d 'Write out the prompt, with conda environment if appropriate'
  # (conda-environment)
  if set -q __CONDA_ENV_ACTIVE
    printf '(%s%s%s) ' (set_color blue) $CONDA_DEFAULT_ENV (set_color normal)
  end
  # whoami@hostname~/P/a/t/h/to/file>
  printf '%s@%s%s%s%s> ' (whoami) (hostname | cut -d . -f 1) \
         (set_color $fish_color_cwd) (prompt_pwd) (set_color normal)
end

function condactivate -d 'Activate a conda environment' -a cenv
  # condabin will be the path to the bin directory
  # in the specified conda environment
  set condabin $MINICONDAPATH/envs/$cenv/bin

  # check whether the condabin directory actually exists and
  # exit the function with an error status if it does not
  if not test -d $condabin
    echo 'Environment not found.'
    return 1
  end

  # deactivate an existing conda environment if there is one
  if set -q __CONDA_ENV_ACTIVE
    deactivate
  end

  # save the current path
  set -xg DEFAULT_PATH $PATH

  # put the condabin directory at the front of the PATH
  set -xg PATH $condabin $PATH

  # this is an undocumented environmental variable that influences
  # how conda behaves when you don't specify an environment for it.
  # https://github.com/conda/conda/issues/473
  set -xg CONDA_DEFAULT_ENV $cenv

  # flag for whether a conda environment has been set
  set -xg __CONDA_ENV_ACTIVE 'true'
end

function deactivate -d 'Deactivate a conda environment'
  if set -q __CONDA_ENV_ACTIVE

    # set PATH back to its default before activating the conda env
    set -xg PATH $DEFAULT_PATH
    set -e DEFAULT_PATH

    # unset this so that conda behaves according to its default behavior
    set -e CONDA_DEFAULT_ENV

    set -e __CONDA_ENV_ACTIVE
  end
end

function condactivate-git-maybe -d 'condactivate/deactivate the current git repo if possible'
  # get the current git repo or empty string
  set git_repo (git rev-parse --show-toplevel ^/dev/null; or echo '')
  # activate or deactivate when entering or leaving environment
  if test -n $git_repo -a -d $MINICONDAPATH/envs/(basename $git_repo)/
    condactivate (basename $git_repo)
  else if set -q __CONDA_ENV_ACTIVE
    deactivate
  end
end

condactivate-git-maybe
functions -c cd __original_cd
function cd -d 'change directory and condactivate/deactivate if possible' -a path
  __original_cd $path
  condactivate-git-maybe
end
