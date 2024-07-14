require 'net/http'
require 'json'
require 'fileutils'
require 'time'

module AtcoderGardener
  class Archiver
    ATCODER_API_SUBMISSION_URL = 'https://kenkoooo.com/atcoder/atcoder-api/v3/user/submissions?user='

    def initialize(config)
      @config = config
    end

    def archive
      user_id = @config[:atcoder][:user_id]
      repository_path = @config[:atcoder][:repository_path]

      uri = URI("#{ATCODER_API_SUBMISSION_URL}#{user_id}&from_second=0")
      response = Net::HTTP.get(uri)
      submissions = JSON.parse(response, symbolize_names: true)

      submissions.select! { |s| s[:result] == 'AC' }

      submissions.each do |submission|
        archive_submission(submission, repository_path)
      end
    end

    def archive_submission(submission, repository_path)
      contest_id = submission[:contest_id]
      problem_id = submission[:problem_id]
      file_name = language_to_file_name(submission[:language])
      dir_path = File.join(repository_path, 'atcoder.jp', contest_id, problem_id)

      FileUtils.mkdir_p(dir_path)
      File.write(File.join(dir_path, file_name), submission[:code])

      submission_file = File.join(dir_path, 'submission.json')
      File.write(submission_file, JSON.pretty_generate(submission))
    end

    def language_to_file_name(language)
      case language
      when /^C\+\+/ then 'Main.cpp'
      when /^Bash/ then 'Main.sh'
      when /^Python/ then 'Main.py'
      when /^Ruby/ then 'Main.rb'
      when 'C' then 'Main.c'
      when 'C#' then 'Main.cs'
      when 'Clojure' then 'Main.clj'
      when /^Common Lisp/ then 'Main.lisp'
      when 'D' then 'Main.d'
      when 'Fortran' then 'Main.f08'
      when 'Go' then 'Main.go'
      when 'Haskell' then 'Main.hs'
      when 'JavaScript' then 'Main.js'
      when 'Java' then 'Main.java'
      when 'OCaml' then 'Main.ml'
      when 'Pascal' then 'Main.pas'
      when 'Perl' then 'Main.pl'
      when 'PHP' then 'Main.php'
      when 'Scala' then 'Main.scala'
      when 'Scheme' then 'Main.scm'
      when 'Text' then 'Main.txt'
      when 'Visual Basic' then 'Main.vb'
      when 'Objective-C' then 'Main.m'
      when 'Swift' then 'Main.swift'
      when 'Rust' then 'Main.rs'
      when 'Sed' then 'Main.sed'
      when 'Awk' then 'Main.awk'
      when 'Brainfuck' then 'Main.bf'
      when 'Standard ML' then 'Main.sml'
      when /^PyPy/ then 'Main.py'
      when 'Crystal' then 'Main.cr'
      when 'F#' then 'Main.fs'
      when 'Unlambda' then 'Main.unl'
      when 'Lua' then 'Main.lua'
      when 'LuaJIT' then 'Main.lua'
      when 'MoonScript' then 'Main.moon'
      when 'Ceylon' then 'Main.ceylon'
      when 'Julia' then 'Main.jl'
      when 'Octave' then 'Main.m'
      when 'Nim' then 'Main.nim'
      when 'TypeScript' then 'Main.ts'
      when 'Perl6' then 'Main.p6'
      when 'Kotlin' then 'Main.kt'
      when 'COBOL' then 'Main.cob'
      else
        'Main.txt'
      end
    end
  end
end
