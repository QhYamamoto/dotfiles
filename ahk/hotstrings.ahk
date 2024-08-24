#Include "./utils.ahk"

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Git commands
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
:x:gia:: Paste("git add ")
:x:giars:: Paste("git reset HEAD")
:x:gic:: Paste('git commit -m ""', 1)
:x:gips:: Paste("git push origin ")
:x:gipl:: Paste("git pull origin ")
:x:gimg:: Paste("git merge ")
:x:gich:: Paste("git switch ")
:x:gibr:: Paste("git branch ")
:x:gist:: Paste("git stash ")
:x:gistu:: Paste("git stash -u -m ''", 1)
:x:gistl:: Paste("git stash list")
:x:gistap:: Paste("git stash apply")
:x:gistd:: Paste("git stash drop")
:x:gicrs:: Paste("git reset --soft HEAD^")
:x:gibrd:: Paste("git branch -D ")
:x:gibrdremote:: Paste("git push origin --delete ")
:x:girb:: Paste("git rebase ")
:x:girbd:: Paste("git rebase develop")
:x:gicp:: Paste("git cherry-pick ")
:x:gifch:: Paste("git_fetch_and_checkout ")
:x:gisq:: Paste("git rebase -i --root")
:x:gilg:: Paste("git log")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Docker/Docker-Compose commands
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
:x:docu:: Paste("docker-compose up")
:x:docud:: Paste("docker-compose up -d")
:x:docd:: Paste("docker-compose down")
:x:docst:: Paste("docker-compose stop")
:x:doccon:: Paste("docker container")
:x:docb:: Paste("docker-compose build")
:x:docbnc:: Paste("docker-compose build --no-cache")
:x:docei:: Paste("docker exec -it  bash", 5)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Artisan commands
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
:x:phar:: Paste("php artisan")
:x:prsr:: Paste("php artisan serve")
:x:prmg:: Paste("php artisan migrate")
:x:prmgsd:: Paste("php artisan migrate --seed")
:x:prmgrs:: Paste("php artisan migrate:reset")
:x:prmgrf:: Paste("php artisan migrate:refresh")
:x:prmgrfsd:: Paste("php artisan migrate:refresh --seed")
:x:prmgrb:: Paste("php artisan migrate:rollback --step=")
:x:prsd:: Paste("php artisan db:seed")
:x:prsdc:: Paste("php artisan db:seed --class=")
:x:prmk:: Paste("php artisan make:")
:x:prmkmd:: Paste("php artisan make:model")
:x:prmkc:: Paste("php artisan make:controller")
:x:prmkmg:: Paste("php artisan make:migration")
:x:prmks:: Paste("php artisan make:seeder")
:x:prrl:: Paste("php artisan route:list")
:x:prcfc:: Paste("php artisan config:cache")
:x:prccc:: Paste("php artisan cache:clear")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Other Utility commands
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
:x:findp:: Paste("lsof -i :")
:x:killp:: Paste("kill -9 ")
:x:msl:: Paste("mysql -u root -p")
