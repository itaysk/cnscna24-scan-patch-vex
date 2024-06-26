package trivy
 
import rego.v1
import data.lib.trivy
dateLayout := "2006-Jan-02"
default ignore = false

allowedCVEs := {
  "CVE-2023-45853",
  "CVE-2024-28085"
}
 
ignore if {
  input.VulnerabilityID in allowedCVEs
  time.now_ns() < time.parse_ns(dateLayout,"2024-Jun-29")
}

ignore if {
  input.PkgName == "libbluetooth3"
}

ignore if {
  cvss := trivy.parse_cvss_vector_v3(input.CVSS.nvd.V3Vector)
  cvss.AttackVector == "Local"
}
