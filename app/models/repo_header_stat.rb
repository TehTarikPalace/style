class RepoHeaderStat < ActiveRecord::Base
  belongs_to :repository
  belongs_to :repo_stat
  belongs_to :stat_header
end
