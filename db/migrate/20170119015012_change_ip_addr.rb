class ChangeIpAddr < ActiveRecord::Migration[5.0]
  def up
    execute "set statement_timeout = 0"
    execute "ALTER TABLE post_versions ALTER COLUMN updater_ip_addr TYPE inet using updater_ip_addr::inet"
    execute "ALTER TABLE pool_versions ALTER COLUMN updater_ip_addr TYPE inet using updater_ip_addr::inet"
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "Can't recover the lost data"
  end
end
