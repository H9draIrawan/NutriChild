import 'package:flutter/material.dart';

class UiHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[50],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hendra Irawan',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 4),
              Text(
                '5 Bulan 3 Hari',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // CalendarDatePicker(initialDate: initialDate, firstDate: firstDate, lastDate: lastDate, onDateChanged: onDateChanged)
                      Icon(Icons.calendar_today, size: 16),
                      SizedBox(width: 8),
                      Text(
                        'Jumat, 7 Desember 2024',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  Stack(
                    alignment: Alignment.topRight,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.notifications, color: Colors.black54, size: 24),
                      ),
                      Positioned(
                        right: 4,
                        top: 4,
                        child: Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildInfoCard('Berat Badan', '8,2 kg', Icons.monitor_weight),
                  _buildInfoCard('Tinggi Badan', '62 cm', Icons.straighten),
                  _buildInfoCard('Lingkar Kepala', '45 cm', Icons.face),
                ],
              ),
              SizedBox(height: 16,width: 5,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionCard('Pantau Pertumbuhan', Icons.baby_changing_station),
                  _buildActionCard('Konsultasi Dokter', Icons.medical_services),
                  _buildActionCard('Edukasi', Icons.lightbulb),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Makanan Hari ini',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              _buildMealCard('Sarapan', '294 kcal', Icons.restaurant),
              _buildMealCard('Makan Siang', '89 kcal', Icons.lunch_dining),
              _buildMealCard('Makan Malam', '56 kcal', Icons.dinner_dining),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.yellow[100],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: Colors.black54),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCard(String title, IconData icon) {
    return Column(
      children: [
        CircleAvatar(
          radius: 28,
          backgroundColor: Colors.yellow[100],
          child: Icon(icon, size: 28, color: Colors.black54),
        ),
        SizedBox(height: 8),
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }

  Widget _buildMealCard(String meal, String kcal, IconData icon) {
    return Card(
      child: ListTile(
        leading: Icon(icon, size: 32, color: Colors.black54),
        title: Text(meal, style: TextStyle(fontSize: 16)),
        subtitle: Text(kcal),
        trailing: Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}
