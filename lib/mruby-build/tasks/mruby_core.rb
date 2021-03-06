module MRuby
  module Tasks
    class MRubyCore < Rake::TaskLib
      def initialize
        MRuby.each_target do
          objs = Dir.glob("#{MRUBY_ROOT}/src/*.c").map { |f|
            next nil if cxx_abi_enabled? and f =~ /(error|vm).c$/

            objfile(f.pathmap("#{build_dir}/src/%n"))
          }.compact

          if cxx_abi_enabled?
            objs += %w(vm error).map { |v| compile_as_cxx "#{MRUBY_ROOT}/src/#{v}.c", "#{build_dir}/src/#{v}.cxx" }
          end
          self.libmruby << objs

          file libfile("#{build_dir}/lib/libmruby_core") => objs do |t|
            archiver.run t.name, t.prerequisites
          end
        end
      end
    end
  end
end
