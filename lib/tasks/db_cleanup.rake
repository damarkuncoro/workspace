namespace :db do
  desc "Membersihkan entri migrasi yang tidak punya file (********** NO FILE **********)"
  task clean: :environment do
    connection = ActiveRecord::Base.connection
    versions_in_db = connection.select_values("SELECT version FROM schema_migrations")
    versions_in_files = Dir.glob("db/migrate/*.rb").map { |f| File.basename(f).split('_').first }

    orphaned_versions = versions_in_db - versions_in_files

    if orphaned_versions.empty?
      puts "✅ Tidak ada migrasi yatim (semua sesuai dengan file)."
    else
      puts "⚠️ Ditemukan migrasi tanpa file:"
      orphaned_versions.each { |v| puts " - #{v}" }

      orphaned_versions.each do |version|
        connection.execute("DELETE FROM schema_migrations WHERE version = '#{version}'")
      end

      puts "🧹 Selesai! Entri migrasi yatim sudah dihapus."
    end
  end
end
