// import android.app.Activity
// import android.content.Context
// import android.net.wifi.p2p.WifiP2pConfig
// import android.net.wifi.p2p.WifiP2pDevice
// import android.net.wifi.p2p.WifiP2pManager
// import android.os.Bundle
// import java.io.File

// class WifiDirectShare : Activity() {
//   private lateinit var wifiP2pManager: WifiP2pManager
//   private lateinit var channel: WifiP2pManager.Channel
//   private lateinit var fileTransferService: FileTransferService

//   override fun onCreate(savedInstanceState: Bundle?) {
//     super.onCreate(savedInstanceState)
//     setContentView(R.layout.activity_main)

//     wifiP2pManager = getSystemService(Context.WIFI_P2P_SERVICE) as WifiP2pManager
//     channel = wifiP2pManager.initialize(this, mainLooper, null)
//     fileTransferService = FileTransferService()

//     // Create a Wi-Fi Direct group
//     wifiP2pManager.createGroup(
//         channel,
//         object : WifiP2pManager.ActionListener {
//           override fun onSuccess() {
//             // Group creation success
//           }

//           override fun onFailure(reason: Int) {
//             // Group creation failure
//           }
//         }
//     )

//     // Discover available peers
//     wifiP2pManager.discoverPeers(
//         channel,
//         object : WifiP2pManager.ActionListener {
//           override fun onSuccess() {
//             // Peers discovered
//           }

//           override fun onFailure(reason: Int) {
//             // Discovery failure
//           }
//         }
//     )

//     // Connect to a peer
//     val device = WifiP2pDevice()
//     wifiP2pManager.connect(
//         channel,
//         WifiP2pConfig().apply { deviceAddress = device.deviceAddress },
//         object : WifiP2pManager.ActionListener {
//           override fun onSuccess() {
//             // Connected to peer
//           }

//           override fun onFailure(reason: Int) {
//             // Connection failure
//           }
//         }
//     )

//     // Send a file
//     val file = File("/path/to/file.txt")
//     fileTransferService.send(
//         file,
//         object : FileTransferService.Callback {
//           override fun onProgressUpdate(sent: Int, total: Int) {
//             // File transfer progress update
//           }

//           override fun onTransferComplete() {
//             // File transfer complete
//           }

//           override fun onTransferError(error: String) {
//             // File transfer error
//           }
//         }
//     )
//   }
// }

// class FileTransferService {
//   private val port = 8888
//   private var socket: Socket? = null

//   fun send(file: File, callback: Callback) {
//     wifiP2pManager.requestConnectionInfo(
//         channel,
//         object : WifiP2pManager.ConnectionInfoListener {
//           override fun onConnectionInfoAvailable(info: WifiP2pInfo) {
//             val host = info.groupOwnerAddress.hostAddress
//             socket = Socket(host, port)
//             val dataOutputStream = DataOutputStream(socket?.getOutputStream())
//             val fileInputStream = FileInputStream(file)
//             val buffer = ByteArray(4096)
//             var bytesRead: Int
//             while (fileInputStream.read(buffer).also { bytesRead = it } != -1) {
//               dataOutputStream.write(buffer, 0, bytesRead)
//             }
//             fileInputStream.close()
//             dataOutputStream.close()
//             socket?.close()
//             callback.onTransferComplete()
//           }
//         }
//     )
//   }

//   interface Callback {
//     fun onProgressUpdate(sent: Int, total: Int)
//     fun onTransferComplete()
//     fun onTransferError(error: String)
//   }
// }
