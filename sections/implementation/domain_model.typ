#import "../../templates/utils.typ": *
#lsp_placate()

#subsection("Domain Model")

#align(
  center, [#figure(
      img("domain_model.svg", width: 100%, extension: "files"), caption: [Domain Model of ReSet],
    )<domain_model>],
)

#subsubsection("Description")
*Persistent Data* | A subset of the service data that will be saved for later
use (persistence).\
*Plugin Data* | Data created for a specific plugin, needs to be provided by the
plugin developer.\
*ReSet* | The graphic user interface for ReSet.\
*ReSet-Daemon* | The backend process for ReSet that handles functionality.\
*Data Transfer Object* | Serialized data that will be sent to ReSet or
third-party applications.

Each functionality defines their DTO that will be sent to the user interface
application, which will then be able to utilize the data.

Plugins will handle their data structure, the daemon will only send the data
to the user interface application, which then in return calls another function
from the plugin, in order to display the data to the user. Additionally, should
a plugin want to store data to persistence, it will have to provide the data to
store in a serializable manner (PersistentData object).

Persistent data is deserialized by the daemon, this data will then be merged
with the runtime data by the adjacent service. This would make functionality
like setting up custom key mappings at startup possible.

