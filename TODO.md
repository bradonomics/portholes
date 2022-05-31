# Create a "local" version

  The system as-is is using 311 MiB of RAM.
  Probably too much to leave running all the time.

  Tasks:
  - Remove devise
    - Have a single user that is auto loaded
  - Remove mailers
    - No point in having mailers if there is no user
  - Remove MetaInspector gem
    - metainspector is using 4.2188 MiB of RAM
  - Remove numbers_and_words gem
    - numbers_and_words is using 3.6094 MiB of RAM

# Auto run on system startup
  - Choose non 3000 and non 4000 port

# Remove calls to .present?
  - https://semaphoreci.com/blog/2017/03/14/faster-rails-how-to-check-if-a-record-exists.html
