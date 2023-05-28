import streamlit as st
from ip2geotools.databases.noncommercial import DbIpCity
import folium

def get_location(ip_address):
    try:
        response = DbIpCity.get(ip_address, api_key='free')
        return response.latitude, response.longitude
    except Exception as e:
        st.error(f"Error: {str(e)}")

def main():
    st.title("IP Location Map")
    ip_address = st.text_input("Enter an IP address:")
    if st.button("Show Location"):
        if ip_address:
            latitude, longitude = get_location(ip_address)
            st.map(folium.Map(location=[latitude, longitude], zoom_start=10))
        else:
            st.warning("Please enter an IP address.")

if __name__ == "__main__":
    main()