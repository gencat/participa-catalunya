#!/bin/sh -x

USER_UID=$(stat -c %u /code/Gemfile)
USER_GID=$(stat -c %g /code/Gemfile)

export USER_UID
export USER_GID
pwd
rm /code/tmp/pids/server.pid

usermod -u "$USER_UID" decidim 2> /dev/null
groupmod -g "$USER_GID" decidim 2> /dev/null
usermod -g "$USER_GID" decidim 2> /dev/null
gem install bundler
# chown -R -h "$USER_UID" "$BUNDLE_PATH"
# chgrp -R -h "$USER_GID" "$BUNDLE_PATH"

# Execute the given or default command replacing the pid 1:
if [ $# -gt 0 ]; then
    echo "== Executing custom command: $* ..."
    exec "$@"
else
    echo "== Installing deps ..."
    bundle check || bundle install
    # yarn install --check-files

    echo "== Running migrations ..."
    if ! bundle exec rake db:migrate
    then
      echo
      echo "== Failed to migrate. Running setup first ..."
      echo
      bundle exec rake db:create db:migrate db:seed
    fi

    echo "== Starting server ..."
    exec bundle exec rails s -b 0.0.0.0
fi