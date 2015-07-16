While answering Powershell questions on reddit I started getting this script complex enough to put it in Git. The poster wants to read 500,000 URLs from a text file and use Invoke-WebRequest on them in parallel. Many times I've wanted to run jobs in parallel, but my attempts weren't very productive, and I wound up manually splitting the input file and just running 4-10 Powershell windows. That won't cut it for 500k requests.

The idea in my head for parallel batch processing in Powershell was to have a dispatcher node and worker nodes, perhaps using a messaging queue to manage them. But it's a big project I never even started.

Before abanoding this reddit poster it occurred to me that a limited number of jobs each running 100 or 1000 or so URLs per job might be a good compromise between total number of job starts and parallel processing.

So I'm working towards setting up a set number of jobs and starting each with a URL queue, but so far I've been incrementally improving the actual per-URL request code and error handling.

reddit post: https://www.reddit.com/r/PowerShell/comments/3den19/powershell_script_to_call_url_from_file/

My initial reply: https://www.reddit.com/r/PowerShell/comments/3den19/powershell_script_to_call_url_from_file/ct4zm6o

**Note:** If you run this, delete or comment out the `Headers = ` line in the `$Parameters` assignnent block or else it will may result in a lot of unexpected responses. (Basically I'm hitting a back-end server to avoid logging my test runs on my main logs, but I have to set the vhost to get the right site in my case.)
