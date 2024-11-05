## My dotfiles
This repo contains my configuration files for various software and dependencies on my linux systems. They get deployed using GNU stow. Each of my systems has this repository that gets updated on login, so that the system you are using always has the latest configuration.

Stow maps these to the correct location.

The way stow works, is that you have a working directory (ie a clone of this repo) and inside that directory you have 'packages'. So each directory in this repo is a 'package' for stow. When you call stow on a package, it looks into the correspnding directory and creates a symbolic link to whatever is in there to a location starting from your home direcotory. A file or directory starting with dot-<something> will be linked to as .<something>.

So:

    Repo
      ╰─ package
          ╰─ dot-file
          ╰─ dot-dir
              ╰─ dir
                  ╰─ file

Will become:

    ~/
      ╰─ .file
          .dir
            ╰─ dir
                ╰─ file

The 'packages' let you bundle files together. You could just use one single package and dump everythting together, but I prefer to different files together and being able to select which ones to use. For instance, it generally use fish and not bash, so I typically do not have links to my bash config files. On a server, I may only need bash and none of the others. It gives freedom. and you can change or adjust at will.
