
### **Project Description: Intelligent Power Management Script**

This PowerShell script is a practical demonstration of my technical proficiency in scripting, hardware integration, and automation. It is designed to monitor a device's battery level in real time and perform specific actions, such as adjusting screen brightness and interacting with external hardware, to ensure efficient energy usage and proactive device management.

---

### **Key Features and Technical Highlights**

1. **Battery Monitoring and Automation:**
   - The script leverages Windows Management Instrumentation (WMI) and CIM (Common Information Model) commands to dynamically monitor the battery charge level.
   - Based on thresholds (e.g., 100% charge), it initiates pre-defined actions, such as sending shutdown commands to prevent overcharging and prolong device lifespan.

2. **Screen Brightness Control:**
   - Implements the `WmiSetBrightness` method to manage screen brightness effectively, showcasing system-level hardware control.

3. **Hardware Communication via Serial Port:**
   - Establishes communication with an external device using a serial port (COM3).
   - Configures baud rate, data bits, and stop bits to send specific commands, reflecting hands-on experience in hardware-software integration.

4. **Real-Time Monitoring:**
   - Incorporates a robust while loop to ensure continuous battery level tracking.
   - Integrates timed intervals for efficient resource utilization without overloading system operations.

5. **File and Process Management:**
   - Scans and lists `.ps1` PowerShell scripts in the user's home directory, demonstrating my ability to manage and automate script-related tasks effectively.

6. **Energy Efficiency Focus:**
   - Includes logic to automate device shutdown at full charge, optimizing power consumption and enhancing hardware durability.

