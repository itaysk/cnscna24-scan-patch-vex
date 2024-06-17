package trivy
 
import data.lib.trivy
import rego.v1
default ignore = false
datelayout := "2006-Jan-02"
denylist := {
  "CVE-2023-30861"
}
 
ignore if {
  input.VulnerabilityID in denylist
}