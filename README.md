# tmux-background-job

Vim plugin to run jobs in a new tmux window.  If a job returns a non 0 exit status, a vertical split with the failing job will be joined with the current window.

## Installation
I've tested installation using [Vundle](https://github.com/gmarik/vundle).  I have not confirmed installation using [Pathogen](https://github.com/tpope/vim-pathogen), so if somebody can confirm, I would appreciate it.

### Using Vundle
Inside your `.vimrc`

```
Bundle 'ajwalters/tmux-background-job'
```

Trigger the install from within vim

```
:BundleInstall
```

### Direct installation
Download the source to your desired destination (eg: `~/Downloads/tmux-background-job`)

Copy/Move the directory to your your vim plugin directory

```
cp -R ~/Downloads/tmux-background-job ~/.vim/plugin/
```

## Configuration
tmux-background-job requires a `.tmux-background-job.conf` configuration file to be present in the current directory of your running vim process.  Currently, you can specify the window index to run jobs, as well as the list of jobs to run.

Sample file format:

```
window: 999
(1) - Current File  [bundle exec rspec %]
(2) - Suite         [bundle exec rspec spec]
```

### Specifying the Window to Run Jobs
The `window:` key defines the window index to run your background jobs.  I've been using a window which will not conflict with other open windows.  In other words, I set this to a high number.  Currently, this is **required**, but should have a sensible default such as next avaiable index

### Specifying Jobs
Every line besides `window:` will be considered a job.  Each line will be presented in a a vim menu upon running `:TmuxBackgroundJob`

Using the same sample file specified above, you'll be presented with the menu:

```
Please select:
(1) - Current File  [bundle exec rspec %]
(2) - Suite         [bundle exec rspec spec]
Type number and <Enter> or click with mouse (empty cancels):
```

The menu is 1-based index.

#### Specifying Commands
Text within `[]` will be executed when you choose that menu selection.  The command will be executed in the tmux session's default-path.  To set the path: `tmux set-option default-path YOUR_PATH_HERE`

There are some special characters which will have substituion perfomred on them.

##### Substitute Current File Into Command
Within the `[]`, a `%` will be substituted with the file the vim cursor is focused on when `:TmuxBackgroundJob` is executed

For example:
If the vim cursor is on the file `~/foo_spec.rb` when `:TmuxBackgroundJob` is executed, `[bundle exec rspec %]` becomes `bundle exec rspec ~/foo_spec.rb`

#### Substitute Current Line Into Command
_Coming Soon…_

## Usage
There are two commands for use: `TmuxBackgroundJob` and `TmuxRerunBackgroundJob`

### TmuxBackgroundJob
This will _always_ launch the menu for you to select your option

### TmuxRerunBackgroundJob
If you have yet to run a background job, `TmuxRerunBackgroundJob` will behave identical to `TmuxBackgroundJob`.  If you have run a background job, `TmuxRerunBackgroundJob` will re-run the previous job

### Assigning Shortcuts
It's recommended you configure shortcuts to quickly execute the two commands.  Out of the box, no shortcuts are defined.

Here's an example of the shortcuts I define in my `~/.vimrc`:

```
let mapleader = ","
map <Leader>s :TmuxBackgroundJob<CR>
map <Leader>r :TmuxRerunBackgroundJob<CR>
```

Now, I can trigger `TmuxBackgroundJob` using `,s` and `TmuxRerunBackgroundJob` using `,r`

## Why?
This plugin was developed to scratch a personal itch around running specs quickly and in the background of my vim process.  I'm aware there are similar plugins out there which accomplish a similar goal.  However, I wanted to develop something not siloed to Ruby/Rails development.  This was also an excuse for me to dive into Vimscript and tmux scripting.

## Contribution
Please fork away and submit pull requests!