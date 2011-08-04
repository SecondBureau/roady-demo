$site_name = $site_code = "Roady_demo"

RorshackAdminUi::ADMINABLE_MODELS <<
  [
    :setting ,
    :page ,
    {:user => [:avatar , :account , :role , :invitees , :invitor] },
    {:product => [:images , :events]},
    {:event => [:images , :products]},
    :event_track
  ]
RorshackAdminUi::ADMINABLE_MODELS.flatten!

