# Grand Stream UCM 6308 Service Ports

For a Grandstream UCM6308 system, the following ports need to be opened or forwarded in your firewall’s NAT server mapping to ensure that Grandstream Wave clients (desktop, web, and Android) work properly:

## SIP Ports

1. **SIP Signaling (UDP/TCP)**:
    - **Port 5060**: For SIP signaling on UDP or TCP.
    - **Port 5061**: For SIP signaling over TLS.

## RTP Ports (for media)

1. **RTP (UDP)**:
    - **Port Range 10000-20000**: This is the default RTP port range for the UCM. Ensure that these are opened for voice media communication.

## HTTP/HTTPS Ports

1. **HTTP (TCP)**:
    - **Port 80**: For accessing the UCM web GUI (not recommended over the internet).
2. **HTTPS (TCP)**:
    - **Port 443**: For secure HTTPS access to the UCM web GUI (recommended over HTTP).

## WebRTC

1. **WebSocket (TCP)**:
    - **Port 8089**: For Grandstream Wave web access and WebRTC communication.

## Additional Ports for Remote Access (if needed)

1. **STUN/TURN/ICE Ports**:
    - If you’re using STUN/TURN servers or ICE for NAT traversal, the ports used by these services will need to be opened as well. Ensure the SBC handles these to avoid NAT issues.

## Session Border Controller (SBC)

Since you're using an SBC, it's crucial that your SBC is configured to manage these SIP and RTP traffic streams and any NAT traversal for external users. You should route SIP signaling and RTP streams through the SBC to handle external connections efficiently.

Make sure your firewall is also handling stateful inspection of SIP (SIP ALG is generally recommended to be disabled to avoid interference).