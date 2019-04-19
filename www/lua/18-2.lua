-- Copyright (C) 2019 by chrono

-- test for infinite loop redirection

--return ngx.redirect("/17-2", 302)
return ngx.redirect("/17-1?dst=17-2", 302)

