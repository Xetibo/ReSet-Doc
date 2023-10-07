#import "../../templates/utils.typ": *
#lsp_placate()

#subsection("Domain Model")

#align(center, [#figure(
    image("../../files/domain_model.svg", width: 100%),
    caption: [Domain Model of ReSet],
  )<domain_model>])

#subsubsection("Description")
*Persistent Data* | A subset of the service data that will be saved for later
use(persistence).\
*Plugin Data* | Data created for a specific plugin, needs to be provided by the
plugin developer.\
*ReSet* | The graphic user interface for ReSet.\
*ReSet-Daemon* | The backend process for ReSet that handles functionality.\
*Data Transfer Object* | Serialized data that will be sent to ReSet or third
party applications.

Plugins will handle their own datastructure, the daemon will only send the data
to the frontend, which then in return calls another function from the plugin, in
order to display the data to the user. Additionally, should a plugin want to
store data to persistence, it will have to provide the data to store in a
serializable manner (PersistentData object).

Persistent data is deserialized by the daemon, this data will then be merged
with the runtime data by the adjacent service. This would make functionality
like automatically trying to reconnect to a default network possible.

Data is transferred individually(1 DTO) per service, this is to both provide
individual access for third party applications and to allow lazy loading of data
by the frontend.

