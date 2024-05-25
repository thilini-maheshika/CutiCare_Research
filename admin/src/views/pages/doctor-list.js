import React, { useState, useEffect, useMemo } from 'react';
// import FormModal from "../FormModal";
import SimpleTable from '../../components/Table';
import Grid from '@mui/material/Grid';
import axios from 'axios';
import { toast } from 'react-toastify';
import 'react-toastify/dist/ReactToastify.css';
import { Box, Button, Modal, TextField, Typography } from '@mui/material';

function DoctorList() {
  const [doctor, setDoctor] = useState([]);
  const [isLoading, setisLoading] = useState(true);
  const [isModalOpen, setIsModalOpen] = useState(false);
  // const [selectedDate, setSelectedDate] = useState(null);

  useEffect(() => {
    fetchData();
  }, []);

  // const openModal = (info) => {
  //   setIsModalOpen(true);
  //   setSelectedDate(info.dateStr);
  // };

  // const closeModal = () => {
  //   setIsModalOpen(false);
  // };

  const handleCloseModal = () => {
    setIsModalOpen(false);
  };

  // const handleSubmit = async (formData) => {
  //   //console.log(formData)
  //   console.log(JSON.stringify(formData));
  //   try {
  //     // Call the postData function with the form data
  //     await addData(formData);
  //     // handleCloseModal();
  //   } catch (error) {
  //     // Handle errors
  //     console.log('Error posting data:', error);
  //     toast.error('Error adding data!');
  //   }
  // };

  const onFinish = (doctor) => {
    doctor.preventDefault();
    const formData = new FormData(doctor.target);
    const formDataObject = Object.fromEntries(formData);
    addData(formData)

    console.log(formDataObject)
  };

  const addData = async (formData) => {
    console.log(formData)
    try {
      const response = await axios.post(
        process.env.REACT_APP_API_ENDPOINT + '/doctor/add',
        formData,
        {
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        }
      );

      // Ensure response status is within the success range (2xx)
      if (response && response.status >= 200 && response.status < 300) {
        console.log(response.data); // Assuming response data contains useful information
      } else {
        // If response status is not within the success range, handle the error
        throw new Error('Failed to add data. Server responded with status: ' + response.status);
      }
    } catch (error) {
      console.error('Error adding data:', error);
      // Optionally rethrow the error to let the calling code handle it further
      throw error;
    } finally {
      // Regardless of success or failure, ensure isLoading is set to false
      setisLoading(false);
    }
  };

  const fetchData = async () => {
    try {
      const response = await axios.get(process.env.REACT_APP_API_ENDPOINT + '/doctor/all');

      if (response.status === 200) {
        setDoctor(response.data.existingEvents);
      }
    } catch (error) {

      console.error(error);
      setError({ message: error.message, has: true });
      toast.error('An error occurred while fetching data.');

    } finally {
      setisLoading(false);
    }
  };

  const deletedata = async (dataArray) => {
    if (dataArray.length > 0) {
      console.log(dataArray);

      // Create a new array with only the 'id' values
      const idArray = dataArray.map((data) => data.id);

      console.log(idArray);

      try {
        // setPending(true);

        const response = await axios.delete(`http://localhost:3006/api/doctor/delete/${idArray}`);

        if (response.status === 200) {
          //   setPending(false);
          fetchData();
          toast.success('Doctor Deleted successfully!');
        } else {
          fetchData();
        }
      } catch (error) {
        if (error.response.status === 401) {
          window.location.reload();
        }
      } finally {
        // setPending(false);
      }
    } else {
      // Handle case when dataArray is empty
    }
  };

  const handleSaveRow = async ({ exitEditingMode, row, values }) => {
    await updateData(row.id, values);
    exitEditingMode();
  };

  const updateData = async (_id, values) => {
    const data = {
      doctor_name: values.doctor_name,
      specialty: values.specialty,
      phonenumber: values.phonenumber,
      profileimage: values.profileimage
    };

    console.log(_id);
    try {
      //   setPending(true);

      const response = await axios.put('http://localhost:3006/api/doctor/' + _id, data);

      if (response.status === 200) {
        // setPending(false);
        toast.success('Doctor updated successfully!');
        fetchData();
      } else if (response.status === 401) {
        window.location.reload();
      } else {
        fetchData();
      }
    } catch (error) {
      if (error.response.status === 401) {
        window.location.reload();
      }
    } finally {
      //   setPending(false);
    }
  };

  const columns = useMemo(
    () => [
      {
        accessorKey: 'doctor_name',
        header: 'Doctor Name',
        enableColumnActions: true
      },

      {
        accessorKey: 'specialty',
        header: 'Specialty',
        enableColumnActions: true
      },

      {
        accessorKey: 'phonenumber',
        header: 'Phone Number',
        enableColumnActions: true
      },

      {
        accessorKey: 'profileimage',
        header: 'Profile Image',
        enableColumnActions: true
      }
    ],
    []
  );

  return (
    <>
      <div className="tabled">
        <Grid container spacing={2}>
          <Grid item xs={24} sm={12}>
            <SimpleTable
              tableHeading="Doctor List"
              columns={columns}
              getData={doctor}
              deletedata={deletedata}
              handleSaveRow={handleSaveRow}
              isLoading={isLoading}
              isModalOpen={isModalOpen}
              setIsModalOpen={setIsModalOpen}
              addButtonHeading="Add Doctor"
              idName="id"
              enableClickToCopy
              enableRowNumbers={false}
              enableRowVirtualization={false}
            />
          </Grid>
        </Grid>
      </div>

      <Modal
        open={isModalOpen}
        onClose={() => setIsModalOpen(false)}
        aria-labelledby="add-user-modal-title"
        aria-describedby="add-user-modal-description"
      >
        {
          <Box
            sx={{
              position: 'absolute',
              top: '50%',
              left: '50%',
              transform: 'translate(-50%, -50%)',
              width: 400,
              bgcolor: '#E8E9EB',
              boxShadow: 24,
              p: 4,
              maxHeight: '90vh',
              overflowY: 'auto'
            }}
          >
            <form name="basic" onSubmit={onFinish} autoComplete="off">
              <Typography variant="h5" align="center" marginBottom={5}>
                Add Doctor
              </Typography>

              <TextField
                label="Doctor Name"
                name="doctor_name"
                variant="outlined"
                fullWidth
                required
                sx={{ mb: 2 }} // Add margin-bottom
              />

              <TextField
                label="Specialty"
                name="specialty"
                variant="outlined"
                fullWidth
                required
                sx={{ mb: 2 }} // Add margin-bottom
              />

              <TextField
                label="Phone Number"
                name="phonenumber"
                variant="outlined"
                fullWidth
                required
                sx={{ mb: 2 }} // Add margin-bottom
              />

              <TextField
                label=""
                name="profileimage"
                variant="outlined"
                type="file"
                fullWidth
                required
                sx={{ mb: 2 }} // Add margin-bottom
              />

              <Box sx={{ mt: 2, display: 'flex', justifyContent: 'center' }}>
                <Button variant="contained" type="submit" sx={{ marginRight: '10px' }}>
                  Submit
                </Button>
                <Button variant="contained" onClick={handleCloseModal} type="button" sx={{ marginLeft: '10px' }}>
                  Cancel
                </Button>
              </Box>
            </form>
          </Box>
        }
      </Modal>
    </>
  );
}

export default DoctorList;
