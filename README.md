
# kickout

a bash script that kicks users out when trying to log into your Arista switch


## Deployment

scp the repo after cloning it to your local machine

```bash
  scp /path/to/repo/clone/kickout user_role@arista_switch:/preferred/path
```
change privileges for kickout.arista_switch
```bash
   chmod +x kickout.sh
```
run the script
```bash
   ./kickout.sh
```
## Appendix

kickout prompt screen allows you to choose between periodically kicking users out or kick all users out only once

